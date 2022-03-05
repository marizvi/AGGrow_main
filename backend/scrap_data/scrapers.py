import abc
import logging
import re
import traceback
from datetime import datetime, timedelta
from time import sleep
from typing import Generic, TypeVar

import feedparser
import requests
from bs4 import BeautifulSoup

from hackmeu.utils import run_in_thread
from scrap_data.models import LatestMandi
from scrap_data.serializers import NewsSerializer

T = TypeVar("T")

logger = logging.getLogger('testlogger')


class BaseScraper(Generic[T], abc.ABC):
    @abc.abstractmethod
    def get_scrape_data(self, *args, **kwargs) -> T:
        raise NotImplementedError


class LatestMandiScraper(BaseScraper[None]):

    def __init__(self):
        self.api_url = "https://enam.gov.in/web/Ajax_ctrl/trade_data_list"
        self.home_url = "https://enam.gov.in/web/dashboard/trade-data"
        self.last_check = datetime.now() - timedelta(minutes=60)

    @staticmethod
    def get_payload(
            from_date: str,
            to_date: str,
            language: str = 'en',
            state_name: str = '-- All --',
            apmc_name: str = '-- Select APMCs --',
            commodity_name: str = '-- Select Commodity --',
    ) -> dict:
        return {
            'fromDate': from_date,
            'toDate': to_date,
            'language': language,
            'stateName': state_name,
            'apmcName': apmc_name,
            'commodityName': commodity_name,
        }

    @staticmethod
    def get_from_date_pattern() -> re.Pattern:
        return re.compile(r'''id=['"]previous_date['"]\s*value=['"]([^'"]+)['"]''')

    def get_from_to_date(self) -> (str, str):
        data = requests.get(self.home_url).text
        logger.info(f"data from home_url {data}")
        from_date = self.get_from_date_pattern().search(data).group(1)
        return from_date, from_date

    @run_in_thread
    def get_scrape_data(self, from_data: str = None, to_date: str = None):
        if datetime.now() - self.last_check < timedelta(minutes=40):
            return
        self.last_check = datetime.now()
        try:
            logger.info("Latest Mandi Scraper started logger")
            logger.info(f"Updating mandi prices")
            if not from_data or to_date:
                from_data, to_date = self.get_from_to_date()
                logger.info(f"from_data: {from_data}")
                logger.info(f"to_date: {to_date}")
            data = requests.post(self.api_url, data=self.get_payload(from_date=from_data, to_date=to_date)).json()
            logger.info(f"data from api {data}")
            assert data['status'] == 200
            data = data['data']
            _all_error = True
            logger.info(f"{len(data)} rows to save")
            logger.info(f"Updating mandi prices")
            for _data in data:
                sleep(5)
                try:
                    LatestMandi.save_from_raw_dict(_data)
                    _all_error = False
                except Exception as e:
                    logger.error(f"{e}")
                    logger.error(f"{traceback.format_exc()}")
            if not _all_error:
                logger.info('mandi prices updated successfully')
        except Exception as e:
            logger.error(f"{e}")
            logger.error(f"{traceback.format_exc()}")


class NewsScrapper(BaseScraper[None]):
    def __init__(self):
        self.api_url = "https://news.google.com/rss/search"
        self.last_check = datetime.now() - timedelta(hours=1)

    @staticmethod
    def get_payload(query: str = "agriculture-india", language: str = "en", country: str = "IN") -> dict:
        return {
            'q': query,
            'hl': f'{language}-{country}',
            'gl': country,
            'ceid': f'{country}:{language}',
        }

    @staticmethod
    def get_image(link):
        response = requests.get(link)
        soup = BeautifulSoup(response.text, 'html.parser')

        imgs = soup.find_all('meta', attrs={'property': 'og:image'})
        if len(imgs) > 0:
            img = imgs[0]['content']
            if img.startswith('http'):
                return img
        return None

    @staticmethod
    def clean_date(date):
        return " ".join(date.split()[:-1])

    @run_in_thread
    def get_scrape_data(self, *args, **kwargs) -> None:
        if datetime.now() - self.last_check < timedelta(minutes=40):
            return
        self.last_check = datetime.now()
        feed = feedparser.parse(self.api_url + '?' + '&'.join([k + '=' + v for k, v in self.get_payload().items()]))
        for item in feed['items']:
            item['published'] = self.clean_date(item['published'])
        feed['items'] = sorted(feed['items'],
                               key=lambda k: datetime.strptime(k['published'], '%a, %d %b %Y %H:%M:%S'),
                               reverse=True)
        for item in feed['items']:
            date = datetime.strptime(item['published'], '%a, %d %b %Y %H:%M:%S')
            image = self.get_image(item['link'])
            source = item.get('source', {}).get('title')
            sleep(5)
            serializer = NewsSerializer(data={
                'title': item['title'],
                'url': item['link'],
                'created_at': date,
                'image': image,
                'source': source,
            })
            if serializer.is_valid():
                serializer.save()
                logger.info(f"{item['title']} saved")
            else:
                logger.error(f"{serializer.errors}")

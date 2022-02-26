import abc
import logging
import re
import sys
import traceback
from datetime import datetime, timedelta
from typing import Generic, TypeVar

import requests

from hackmeu.utils import run_in_thread
from scrap_data.models import LatestMandi

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
        try:
            logger.info("Latest Mandi Scraper started logger")

            if self.last_check > datetime.now() - timedelta(minutes=40):
                return
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
                try:
                    LatestMandi.save_from_raw_dict(_data)
                    _all_error = False
                except Exception as e:
                    logger.error(f"{e}")
                    logger.error(f"{traceback.format_exc()}")
            if not _all_error:
                self.last_check = datetime.now()
        except Exception as e:
            logger.error(f"{e}")
            logger.error(f"{traceback.format_exc()}")

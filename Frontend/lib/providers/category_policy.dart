import 'package:flutter/cupertino.dart';
import 'package:hackathon_app/providers/content.dart';

class CategoryPolicy with ChangeNotifier {
  final String id;
  final String title;
  final String url;
  final List<Content> content;

  CategoryPolicy({
    required this.id,
    required this.title,
    required this.url,
    required this.content,
  });
}

class Policies with ChangeNotifier {
  // ignore: prefer_final_fields
  List<CategoryPolicy> items = [
    CategoryPolicy(
      id: "1",
      title: 'Agriculture Schemes',
      url:
          "https://www.ingovtscheme.com/wp-content/uploads/2020/08/Pradhan-Mantri-Kisan-Maan-dhan-Yojana.png",
      content: [
        Content(
            cid: 'a1',
            title: 'PM-Kisan Scheme',
            desc:
                'Pradhan Mantri Kisan Samman Nidhi Yojana is an initiative of the Government wherein 120 million small and marginal farmers of India with less than two hectares of landholding will get up to Rs. 6,000 per year as minimum income support. PM-Kisan scheme has become operational since 1st December 2018. Under this scheme, cultivators will get Rs. 6000 in three installments',
            url: 'www.pmkisan.gov.in/'),
        Content(
            cid: 'a2',
            title: 'PM-Pradhan Mantri Kisan Maandhan yojana',
            desc:
                '''Prime Minister Narendra Modi launched a pension scheme for the small & marginal farmers of India last September. Under PM Kisan Maandhan scheme about 5 crore marginalised farmers will get a minimum pension of Rs 3000 / month on attaining the age of 60. Those who fall in the age group of 18 - 40 years will be eligible to apply for the scheme. Under this scheme, the farmers will
                 be required to make a monthly contribution of Rs 55 to 200, depending on their age of entry, in the Pension Fund till they reach the retirement date, 60 years. The Government will make an equal contribution of the same amount in the pension fund for the cultivators.''',
            url: 'https://pmkmy.gov.in/'),
        Content(
            cid: 'a3',
            title: '''3 Kisan Credit Card (KCC) scheme''',
            desc:
                '''Kisan Credit Card scheme is yet another important Government scheme that provides farmers with timely access to credit. Kisan Credit Card scheme was introduced in 1998 to provide short-term formal credit to the farmers. KCC scheme was launched to ensure that the credit requirements for cultivators in the agriculture, fisheries & animal 
                husbandry sector were being met. Under this scheme, farmers are given short-term loans to purchase equipment & for their other expenses as well. There are many banks that offer KCC including SBI, HDFC, ICICI, Axis. ''',
            url:
                'https://krishijagran.com/news/how-to-apply-for-kisan-credit-card-online-check-step-by-step-process/'),
        Content(
            cid: 'a4',
            title: 'Pashu Kisan Credit Card Scheme',
            desc:
                '''Pradhan Mantri Kisan Samman Nidhi Yojana is an initiative of the Government wherein 120 million,
                 small and marginal farmers of India with less than two hectares of landholding will get up to Rs. 6,000 per year as minimum income support. PM-Kisan scheme has become operational since 1st December 2018. Under this scheme, cultivators will get Rs. 6000 in three installments''',
            url:
                'https://krishijagran.com/agriculture-world/pashu-kisan-credit-card-yojana-eligibility-benefits-loan-amount-necessary-documents-methods-to-apply/'),
        Content(
          cid: 'a5',
          title: 'Paramparagat Krishi Vikas Yojana (PKVY)',
          desc:
              '''Pradhan Mantri Kisan Samman Nidhi Yojana is an initiative of the Government wherein 120 million small and marginal farmers of India with less than two hectares of landholding will get up to,
                 Rs. 6,000 per year as minimum income support. PM-Kisan scheme has become operational since 1st December 2018. Under this scheme, cultivators will get Rs. 6000 in three installments''',
          url:
              'https://krishijagran.com/agriculture-world/how-farmers-can-get-rs-50000-per-hectare-for-organic-farming-under-paramparagat-krishi-vikas-yojana/',
        ),
        Content(
          cid: 'a6',
          title: '''Pradhan Mantri Krishi Sinchai Yojana (PMKSY)''',
          desc:
              '''With the motto ‘Har Khet Ko Paani’ to provide end-to end solutions in irrigation supply chain, viz. water sources, distribution network & farm level applications. PMKSY 
              focuses on creating sources for assured irrigation, also creating protective irrigation by harnessing rain water at micro level through ‘Jal Sanchay’ & ‘Jal Sinchan’''',
          url:
              'https://krishijagran.com/agriculture-world/how-farmers-can-get-rs-50000-per-hectare-for-organic-farming-under-paramparagat-krishi-vikas-yojana/',
        ),
        Content(
          cid: 'a8',
          title: '''Soil Health Card Scheme''',
          desc:
              '''Soil health card scheme was launched in the year 2015 in order to help the State Governments to issue Soil Health Cards to farmers of India. 
               The Soil Health Cards gives information to farmers on nutrient status of their soil along with recommendation on appropriate dosage of nutrients to be applied for improving soil health and its fertility. Check for more information soilhealth.dac.gov.in/''',
          url:
              'https://krishijagran.com/agripedia/benefits-of-soil-health-card-scheme/',
        ),
        Content(
          cid: 'a9',
          title: '''National Mission for Sustainable Agriculture (NMSA)''',
          desc:
              '''National Mission for Sustainable Agriculture is one of the eight Missions under the National 
              Action Plan on Climate Change (NAPCC). It is aimed at promoting Sustainable Agriculture via climate change adaptation measures, boosting agriculture productivity especially in Rainfed areas focusing on integrated farming, soil health management & synergizing resource conservation''',
          url: '',
        ),
        Content(
          cid: 'a10',
          title: '''Livestock insurance Scheme''',
          desc:
              '''Livestock insurance Scheme is aimed at providing protection mechanism to farmers as well as cattle rearers against any eventual loss of animals because of death. The scheme also tells about the benefit of 
              insurance of livestock to dairy farmers and popularizes it with the ultimate goal of attaining a qualitative improvement in livestock & their products.''',
          url: 'http://dadf.gov.in/related-links/livestock-insurance',
        ),
      ],
    ),
    CategoryPolicy(
      id: "2",
      title: 'Agricultural Loans in India',
      url: "https://innovatenow.in/wp-content/uploads/2019/04/July-20.png",
      content: [
        Content(
            cid: 'b1',
            title: 'Kisan Credit Card Scheme',
            desc:
                '''Pradhan Mantri Kisan Samman Nidhi Yojana is an initiative of the Government wherein 120 
                million small and marginal farmers of India with less than two hectares of landholding will get up to Rs. 6,000 per year as minimum income support. PM-Kisan scheme has become operational since 1st December 2018. Under this scheme, cultivators will get Rs. 6000 in three installments''',
            url: 'www.pmkisan.gov.in/'),
        Content(
            cid: 'b2',
            title: 'Kisan Credit Card Scheme',
            desc: '''This has been particularly beneficial for those farmers who
                 are not aware of the banking practices. Moreover, it is meant to protect farmers from harsh and informal creditors, which may land them in a massive debt. The farmers can use the KCC card to withdraw funds for the purpose of crop production and domestic requirements.''',
            url: 'https://www.bankbazaar.com/kisan-credit-card.html'),
        Content(
            cid: 'b3',
            title: '''Other Similar Types of Agricultural Loan Schemes''',
            desc:
                '''Dairy Entrepreneurship Development Scheme: This scheme is meant to promote the dairy sector, specifically by setting up modernized 
                dairy farms, promoting calf rearing, provide infrastructure, upgrading logistical operations to improve the product on a commercial scale, and generate self-employment. ''',
            url:
                'https://krishijagran.com/news/how-to-apply-for-kisan-credit-card-online-check-step-by-step-process/'),
      ],
    ),
    CategoryPolicy(
      id: "3",
      title: 'Crop insurance schemes in India',
      url:
          "https://static.vikaspedia.in/media/images_en/agriculture/agri-insurance/pmfby.jpg",
      content: [
        Content(
            cid: 'c1',
            title: 'Pradhan Mantri Fasal Bima Yojana Image',
            desc:
                '''Insurance protection for food crops, oilseeds and annual horticultural/commercial crops notified by state government.\n
                The difference between actual premium and the rate of Insurance payable by farmers shall be shared equally by the Centre and State.
                ''',
            url: 'www.pmkisan.gov.in/'),
        Content(
            cid: 'c2',
            title: '''Weather Based Crop Insurance Scheme (WBCIS) IMage''',
            desc:
                '''When the Weather indices (rainfall/temperature/relative humidity/wind speed etc) is different (less/ higher) from the Guaranteed Weather Index of notified crops, the claim payment equal to deviation/shortfall is payable to all insured farmers of notified area.
                  Provision for assessment of losses caused by hailstorm and cloud burst at individual farm level.
                  Implementing agency will be selected by the State Government through bid.
                  ''',
            url: ''),
        Content(
            cid: 'c3',
            title: '''Coconut Palm Insurance Scheme (CPIS)''',
            desc:
                '''Insurance protection for Coconut Palm growers.Premium rate per
                 palm ranges from Rs. 9.00 (in the plant age group of 4 to 15 years) to Rs. 14.00 (in the plant age group of 16-60 years). ''',
            url: ''),
        Content(
            cid: 'c4',
            title:
                '''Unified Package Insurance Scheme (UPIS) as pilot in 45 districts ''',
            desc:
                '''Insurance protection for Coconut Palm growers.Premium rate per
                 palm ranges from Rs. 9.00 (in the plant age group of 4 to 15 years) to Rs. 14.00 (in the plant age group of 16-60 years). ''',
            url:
                'https://vikaspedia.in/agriculture/agri-insurance/unified-package-insurance-scheme'),
      ],
    ),
  ];

  List<CategoryPolicy> get elements {
    return [...items];
  }

  List<dynamic> findCategory(String id) {
    var list = items.firstWhere((element) => element.id == id);
    var list2 = list.content
        .map((value) => {
              'cid': value.cid,
              'title': value.title,
              'desc': value.desc,
              'url': value.url,
            })
        .toList();
    // print(list2);
    return list2;
    // return
  }

  Map<String, String> findContent(String id, String cid) {
    final contentList = findCategory(id);
    var temp = contentList.firstWhere((value) => value['cid'] == cid);
    return temp;
    // return
  }
}

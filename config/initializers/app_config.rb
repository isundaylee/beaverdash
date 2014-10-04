APP_CONFIG = {
  gmail: {
    credentials_file: File.join(Rails.root, 'tmp/gmail_credentials'),
    username: 'beaverdash.receiver',
    password: 'beaverdashpass'
  },
  yo: {
    api_key: 'a5995080-2eac-799e-f3e1-f129038851c6'
  },
  parse: {
    building_numbers: ["1", "2", "3", "4", "5", "6", "6B", "6C", "7", "7A", "8", "9", "10", "11", "12", "12A", "13", "14", "14N", "14S", "14W", "14E", "16", "17", "18", "24", "26", "31", "32", "32G", "32D", "32P", "33", "34", "35", "36", "37", "38", "39", "41", "42", "43", "44", "46", "48", "50", "51", "54", "56", "57", "62", "64", "66", "68", "76", "E1", "E2", "E14", "E15", "E17", "E18", "E19", "E23", "E25", "E33", "E34", "E38", "E40", "E51", "E52", "E53", "E55", "E60", "E62", "N4", "N9", "N10", "N16", "N16A", "N16B", "N16C", "N51", "N52", "N57", "NW10", "NW12", "NW12A", "NW13", "NW14", "NW15", "NW16", "NW17", "NW20", "NW21", "NW22", "NW30", "NW35", "NW61", "NW86", "NW86P", "OC1", "OC1A", "OC19A", "OC19B", "OC19C", "OC19D", "OC19E", "OC19F", "OC19G", "OC19H", "OC19J", "OC19K", "OC19L", "OC19M", "OC19N", "OC19Q", "OC21", "OC22", "OC23", "OC25", "OC26", "OC31", "OC31A", "OC32", "OC32A", "OC32B", "OC33", "OC35", "OC36", "OC36A", "W1", "W2", "W4", "W5", "W7", "W8", "W11", "W13", "W15", "W16", "W20", "W31", "W32", "W33", "W34", "W35", "W45", "W51", "W51C", "W53", "W53A", "W53B", "W53C", "W53D", "W56", "W57", "W57A", "W59", "W61", "W64", "W70", "W71", "W79", "W84", "W85", "W89", "W91", "W92", "W98", "W85DE", "W85FG", "WW15", "W85ABC", "W85HJK"],
    location_signal_words: ['lounge', 'lobby', 'tower'],
    building_names: {
      'rotch' => '7A',
      'hayden' => '14',
      'dorrance' => '16',
      'dreyfus' => '18',
      'compton' => '26',
      'stata' => '32',
      'walker' => '50',
      'green building' => '54',
      'whitaker' => '56',
      'east campus' => '62',
      'senior' => 'e2',
      'tang center' => 'e51',
      'mit museum' => 'n52',
      'ashdown' => 'nw35',
      'random' => 'nw61',
      'maseeh' => 'w1',
      'mccormick' => 'w4',
      'baker' => 'w7',
      'bexley' => 'w13',
      'chapel' => 'w15',
      'kresge' => 'w16',
      'student center' => 'w20',
      'rockwell' => 'w33',
      'johnson' => 'w34',
      'burton-conner' => 'w51',
      'burton conner' => 'w51',
      'macgregor' => 'w61',
      'new house' => 'w70',
      'next house' => 'w71',
      'simmons' => 'w79',
      'westgate' => 'w85'
    }
  }
}

APP_CONFIG ||= {}
APP_CONFIG = APP_CONFIG.deep_merge({
  gmail: {
    credentials_file: File.join(Rails.root, 'tmp/gmail_credentials'),
  },
  parse: {
    building_numbers: ["1", "2", "3", "4", "5", "6", "6B", "6C", "7", "7A", "8", "9", "10", "11", "12", "12A", "13", "14", "14N", "14S", "14W", "14E", "16", "17", "18", "24", "26", "31", "32", "32G", "32D", "32P", "33", "34", "35", "36", "37", "38", "39", "41", "42", "43", "44", "46", "48", "50", "51", "54", "56", "57", "62", "64", "66", "68", "76", "E1", "E2", "E14", "E15", "E17", "E18", "E19", "E23", "E25", "E33", "E34", "E38", "E40", "E51", "E52", "E53", "E55", "E60", "E62", "N4", "N9", "N10", "N16", "N16A", "N16B", "N16C", "N51", "N52", "N57", "NW10", "NW12", "NW12A", "NW13", "NW14", "NW15", "NW16", "NW17", "NW20", "NW21", "NW22", "NW30", "NW35", "NW61", "NW86", "NW86P", "OC1", "OC1A", "OC19A", "OC19B", "OC19C", "OC19D", "OC19E", "OC19F", "OC19G", "OC19H", "OC19J", "OC19K", "OC19L", "OC19M", "OC19N", "OC19Q", "OC21", "OC22", "OC23", "OC25", "OC26", "OC31", "OC31A", "OC32", "OC32A", "OC32B", "OC33", "OC35", "OC36", "OC36A", "W1", "W2", "W4", "W5", "W7", "W8", "W11", "W13", "W15", "W16", "W20", "W31", "W32", "W33", "W34", "W35", "W45", "W51", "W51C", "W53", "W53A", "W53B", "W53C", "W53D", "W56", "W57", "W57A", "W59", "W61", "W64", "W70", "W71", "W79", "W84", "W85", "W89", "W91", "W92", "W98", "W85DE", "W85FG", "WW15", "W85ABC", "W85HJK"],
    location_signal_words: ['lounge', 'lobby'],
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
    },
    foods: ["acorn squash", "alfalfa sprouts", "almond", "anchovy", "anise", "appetizer", "appetite", "apple", "apricot", "artichoke", "asparagus", "aspic", "ate", "avocado", "bacon", "bagel", "bake", "baked Alaska", "bamboo shoots", "banana", "barbecue", "barley", "basil", "batter", "beancurd", "beans", "beef", "beet", "bell pepper", "berry", "biscuit", "bitter", "black beans", "blackberry", "black-eyed peas", "black tea", "bland", "blood orange", "blueberry", "boil", "bowl", "boysenberry", "bran", "bread", "breadfruit", "breakfast", "brisket", "broccoli", "broil", "brownie", "brown rice", "brunch", "Brussels sprouts", "buckwheat", "buns", "burrito", "butter", "butter bean", "cake", "calorie", "candy", "candy apple", "cantaloupe", "capers", "caramel", "caramel apple", "carbohydrate", "carrot", "cashew", "cassava", "casserole", "cater", "cauliflower", "caviar", "cayenne pepper", "celery", "cereal", "chard", "cheddar", "cheese", "cheesecake", "chef", "cherry", "chew", "chicken", "chick peas", "chili", "chips", "chives", "chocolate", "chopsticks", "chow", "chutney", "cilantro", "cinnamon", "citron", "citrus", "clam", "cloves", "cobbler", "coconut", "cod", "coffee", "coleslaw", "collard greens", "comestibles", "cook", "cookbook", "cookie", "corn", "cornflakes", "cornmeal", "cottage cheese", "crab", "crackers", "cranberry", "cream", "cream cheese", "crepe", "crisp", "crunch", "crust", "cucumber", "cuisine", "cupboard", "cupcake", "curds", "currants", "curry", "custard", "daikon", "daily bread", "dairy", "dandelion greens", "Danish pastry", "dates", "dessert", "diet", "digest", "digestive system", "dill", "dine", "diner", "dinner", "dip", "dish", "dough", "doughnut", "dragonfruit", "dressing", "dried", "drink", "dry", "durian", "eat", "Edam cheese", "edible", "egg", "eggplant", "elderberry", "endive", "entree", "fast", "fat", "fava bans", "feast", "fed", "feed", "fennel", "fig", "fillet", "fire", "fish", "flan", "flax", "flour", "food", "food pyramid", "foodstuffs", "fork", "freezer", "French fries", "fried", "fritter", "frosting", "fruit", "fry", "garlic", "gastronomy", "gelatin", "ginger", "gingerale", "gingerbread", "glasses", "Gouda cheese", "grain", "granola", "grape", "grapefruit", "grated", "gravy", "greenbean", "greens", "green tea", "grub", "guacamole", "guava", "gyro", "herbs", "halibut", "ham", "hamburger", "hash", "hazelnut", "herbs", "honey", "honeydew", "horseradish", "hot", "hot dog", "hot sauce", "hummus", "hunger", "hungry", "ice", "iceberg lettuce", "iced tea", "icing", "ice cream", "ice cream cone", "jackfruit", "jalapeno", "jam", "jelly", "jellybeans", "jicama", "jimmies", "Jordan almonds", "jug", "julienne", "juice", "junk food", "kale", "kebab", "ketchup", "kettle", "kettle corn", "kidney beans", "kitchen", "kiwi", "knife", "kohlrabi", "kumquat", "ladle", "lamb", "lard", "lasagna", "legumes", "lemon", "lemonade", "lentils", "lettuce", "licorice", "lima beans", "lime", "liver", "loaf", "lobster", "lollipop", "loquat", "lox", "lunch", "lunch box", "lunchmeat", "lychee", "macaroni", "macaroon", "main course", "maize", "mandarin orange", "mango", "maple syrup", "margarine", "marionberry", "marmalade", "marshmallow", "mashed potatoes", "mayonnaise", "meat", "meatball", "meatloaf", "melon", "menu", "meringue", "micronutrient", "milk", "milkshake", "millet", "mincemeat", "minerals", "mint", "mints", "mochi", "molasses", "mole sauce", "mozzarella", "muffin", "mug", "munch", "mushroom", "mussels", "mustard", "mustard greens", "mutton", "napkin", "nectar", "nectarine", "nibble", "noodles", "nosh", "nourish", "nourishment", "nut", "nutmeg", "nutrient", "nutrition", "nutritious", "oats", "oatmeal", "oil", "okra", "oleo", "olive", "omelet", "omnivore", "onion", "orange", "order", "oregano", "oven", "oyster", "pan", "pancake", "papaya", "parsley", "parsnip", "pasta", "pastry", "pate", "patty", "pattypan squash", "peach", "peanut", "peanut butter", "pea", "pear", "pecan", "peapod", "pepper", "pepperoni", "persimmon", "pickle", "picnic", "pie", "pilaf", "pineapple", "pita bread", "pitcher", "pizza", "plate", "platter", "plum", "poached", "pomegranate", "pomelo", "pop", "popsicle", "popcorn", "popovers", "pork", "pork chops", "pot", "potato", "pot roast", "preserves", "pretzel", "prime rib", "protein", "provisions", "prune", "pudding", "pumpernickel", "pumpkin", "punch", "quiche", "quinoa", "saffron", "sage", "salad", "salami", "salmon", "salsa", "salt", "sandwich", "sauce", "sauerkraut", "sausage", "savory", "scallops", "scrambled", "seaweed", "seeds", "sesame seed", "shallots", "sherbet", "shish kebab", "shrimp", "slaw", "slice", "smoked", "snack", "soda", "soda bread", "sole", "sorbet", "sorghum", "sorrel", "soup", "sour", "sour cream", "soy", "soybeans", "soysauce", "spaghetti", "spareribs", "spatula", "spices", "spicy", "spinach", "split peas", "spoon", "spork", "sprinkles", "sprouts", "spuds", "squash", "squid", "steak", "stew", "stir-fry", "stomach", "stove", "straw", "strawberry", "string bean", "stringy", "strudel", "sub sandwich", "submarine sandwich", "succotash", "suet", "sugar", "summer squash", "sundae", "sunflower", "supper", "sushi", "sustenance", "sweet", "sweet potato", "Swiss chard", "syrup", "taco", "take-out", "tamale", "tangerine", "tapioca", "taro", "tarragon", "tart", "tea", "teapot", "teriyaki", "thyme", "toast", "toaster", "toffee", "tofu", "tomatillo", "tomato", "torte", "tortilla", "tuber", "tuna", "turkey", "turmeric", "turnip", "ugli fruit", "unleavened", "utensils", "vanilla", "veal", "vegetable", "venison", "vinegar", "vitamin", "wafer", "waffle", "walnut", "wasabi", "water", "water chestnut", "watercress", "watermelon", "wheat", "whey", "whipped cream", "wok", "yam", "yeast", "yogurt", "yolk", "zucchini", "chinese", "thai", "indian", "mexican", "italian"]
  },
  router_nodes: {
    data_file: File.join(Rails.root, 'tmp/router_nodes.csv'),
    point_data: File.join(Rails.root, 'tmp/points.csv')
  }
})

enum SortType { dates_asc, dates_desc, leaves_asc, leaves_desc, comments_asc, comments_desc }

Map<SortType, String> sortOptions = {
  SortType.dates_asc : "Najstariji",
  SortType.dates_desc : "Najnoviji",
  SortType.leaves_asc : "Najmanje lajkova",
  SortType.leaves_desc : "Najviše lajkova",
  SortType.comments_asc : "Najmanje komentara",
  SortType.comments_desc : "Najviše komentara"
};
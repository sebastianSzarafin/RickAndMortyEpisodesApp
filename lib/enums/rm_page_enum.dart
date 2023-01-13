enum PageEnum {
  characters,
  episodes,
  locations,
}

String getPageString(PageEnum pageEnum) {
  switch (pageEnum) {
    case PageEnum.characters:
      return 'characters';
    case PageEnum.episodes:
      return 'episodes';
    case PageEnum.locations:
      return 'locations';
  }
}

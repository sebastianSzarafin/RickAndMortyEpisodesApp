const allEpisodesGraphQL = """
query episodes {
  episodes(page: 1) {
    info{
      count
    }
  }
}

""";

const allEpisodesGraphQL = """
query(\$page: Int) {
  episodes(page: \$page) {
    info {
      count
      next
      prev
    }
    results {
      id
      name
      episode
    }
  }
}
""";

const allCharactersGraphQL = """
query(\$page: Int) {
  characters(page: \$page) {
    info {
      count
      next
      prev
    }
    results {
      id
      name
      image
    }
  }
}
""";

const singleCharacterGraphQL = """
query(\$id: ID!) {
  character(id: \$id) {
    name
    status
    species
    type
    gender
    origin {
      name
    }
    location {
      name
    }
    episode {
      name
      episode
    }
  }
}
""";

const singleEpisodeCharactersGraphQl = """
query(\$id: ID!) {
  episode(id: \$id) {
    characters {
      name
      species
      gender
      image
    }
  }
}
""";

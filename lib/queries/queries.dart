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

const allLocationsGraphQL = """
query(\$page: Int) {
  locations(page: \$page) {
    info {
      count
      next
      prev
    }
    results {
      id
      name
      type
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

const singleCharacterGraphQL = """
query(\$id: ID!) {
  character(id: \$id) {
    id
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
      id
      name
      episode
    }
  }
}
""";

const singleLocationGraphQL = """
query(\$id: ID!) {
  location(id: \$id) {
    id
    name
    type
    dimension
    residents {
      name
      species
      gender
      image
    }
  }
}
""";

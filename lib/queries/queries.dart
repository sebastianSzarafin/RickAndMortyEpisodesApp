const allEpisodesGraphQL = """
query(\$page: Int) {
  episodes(page: \$page) {
    info{
      count,
      next,
      prev
    }
    results{
      id
      name
      episode
    }
  }
}
""";

const singleEpisodeGraphQL = """
query(\$id: ID!) {
  episode(id: \$id) {
    id
    name
	  episode 
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

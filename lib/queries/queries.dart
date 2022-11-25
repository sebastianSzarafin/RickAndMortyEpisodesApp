const allEpisodesGraphQL = """
query {
  episodes(page: 1) {
    info{
      count
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

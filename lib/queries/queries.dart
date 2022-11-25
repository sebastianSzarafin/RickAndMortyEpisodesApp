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
query episode(\$id: ID!) {
  episode(id: \$id) {
    id
    name
	  episode 
  }
}
""";

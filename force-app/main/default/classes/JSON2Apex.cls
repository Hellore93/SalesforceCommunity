/**
 * Created by  on .
 */


public class JSON2Apex {

    public Dates dates;
    public Integer page;
    public List<Results> results;
    public Integer total_pages;
    public Integer total_results;

    public class Results {
        public Boolean adult;
        public String backdrop_path;
        public List<Integer> genre_ids;
        public Integer id;
        public String original_language;
        public String original_title;
        public String overview;
        public Double popularity;
        public String poster_path;
        public String release_date;
        public String title;
        public Boolean video;
        public Double vote_average;
        public Integer vote_count;
    }

    public class Dates {
        public String maximum;
        public String minimum;
    }


    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
}
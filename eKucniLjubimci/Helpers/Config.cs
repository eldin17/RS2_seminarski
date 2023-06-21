namespace eKucniLjubimci.Helpers
{
    public class Config
    {
        public static string url = "http://localhost:7152/";

        public static string SlikeArtikala => "SlikeArtikala/";
        public static string SlikeArtikalaUrl => url + SlikeArtikala;
        public static string SlikeArtikalaFolder => "wwwroot/" + SlikeArtikala;
        //------------------------------------------------------------------------------
        public static string SlikeZivotinja => "SlikeZivotinja/";
        public static string SlikeZivotinjaUrl => url + SlikeZivotinja;
        public static string SlikeZivotinjaFolder => "wwwroot/" + SlikeZivotinja;
        //------------------------------------------------------------------------------
        public static string SlikeKupaca => "SlikeKupaca/";
        public static string SlikeKupacaUrl => url + SlikeKupaca;
        public static string SlikeKupacaFolder => "wwwroot/" + SlikeKupaca;
        //------------------------------------------------------------------------------
        public static string SlikeProdavaca => "SlikeProdavaca/";
        public static string SlikeProdavacaUrl => url + SlikeProdavaca;
        public static string SlikeProdavacaFolder => "wwwroot/" + SlikeProdavaca;
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.SearchObjects
{
    public class SearchNarudzba : BaseSearch
    {
        public int? KupacId { get; set; }
        public string? KupacIme { get; set; }
        public string? KupacPrezime { get; set; }
        public decimal? TotalDo { get; set; }
        public decimal? TotalOd { get; set; }
    }
}

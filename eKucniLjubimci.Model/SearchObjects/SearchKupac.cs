using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.SearchObjects
{
    public class SearchKupac:BaseSearch
    {
        public int? BrojNarudzbi { get; set; }
        public bool? Kuca { get; set; }
        public bool? Dvoriste { get; set; }
        public bool? Stan { get; set; }
        public string? ImePrezime { get; set; } = null!;

    }
}

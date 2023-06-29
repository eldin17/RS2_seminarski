using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.SearchObjects
{
    public class SearchKupac:BaseSearch
    {
        public int? BrojNarudzbiOd { get; set; }
        public int? BrojNarudzbiDo { get; set; }
        public bool? Kuca { get; set; }
        public bool? Dvoriste { get; set; }
        public bool? Stan { get; set; }
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public string? Grad { get; set; }
        public string? Drzava { get; set; }

    }
}

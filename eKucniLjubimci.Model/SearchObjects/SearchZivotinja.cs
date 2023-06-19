using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.SearchObjects
{
    public class SearchZivotinja : BaseSearch
    {
        public string? Naziv { get; set; }
        public int? VrstaId { get; set; }
        public decimal? CijenaDo { get; set; }
        public decimal? CijenaOd { get; set; }
        public bool? Dostupnost { get; set; }
    }
}

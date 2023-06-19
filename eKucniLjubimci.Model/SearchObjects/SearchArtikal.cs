using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.SearchObjects
{
    public class SearchArtikal : BaseSearch
    {
        public string? Naziv { get; set; }
        public decimal? CijenaDo { get; set; }
        public decimal? CijenaOd { get; set; }
    }
}

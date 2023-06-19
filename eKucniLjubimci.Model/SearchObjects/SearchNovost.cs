using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.SearchObjects
{
    public class SearchNovost : BaseSearch
    {
        public string? Naslov { get; set; }
        public int? ProdavacId { get; set; }

    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.SearchObjects
{
    public class SearchOsoba : BaseSearch
    {
        public string? Ime { get; set; } = null!;
        public string? Prezime { get; set; } = null!;
    }
}

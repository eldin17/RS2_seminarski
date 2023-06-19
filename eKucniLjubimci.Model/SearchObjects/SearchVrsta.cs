using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.SearchObjects
{
    public class SearchVrsta : BaseSearch
    {
        public string? Naziv { get; set; }
        public string? Rasa { get; set; }
        public string? Boja { get; set; }
        public int? StarostDo { get; set; }
        public int? StarostOd { get; set; }
        public bool? Prostor { get; set; }
    }
}

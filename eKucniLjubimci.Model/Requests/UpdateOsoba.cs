using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class UpdateOsoba
    {
        public string? Ime { get; set; }
        public string? Prezime { get; set; }
        public DateTime? DatumRodjenja { get; set; }
    }
}

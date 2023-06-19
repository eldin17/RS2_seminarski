using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddOsoba
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Ime-")]
        public string Ime { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Prezime-")]
        public string Prezime { get; set; }
        [Required(ErrorMessage = "Obavezno polje -DatumRodjenja-")]
        public DateTime DatumRodjenja { get; set; }
    }
}

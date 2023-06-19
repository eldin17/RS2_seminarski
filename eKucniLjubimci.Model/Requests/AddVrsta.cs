using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddVrsta
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Naziv-")]
        public string Naziv { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Rasa-")]
        public string Rasa { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Opis-")]
        public string Opis { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Boja-")]
        public string Boja { get; set; }

        [Range(1, 300, ErrorMessage = "Starost mora biti u rasponu 1-300")]
        public int Starost { get; set; }
        public bool Prostor { get; set; } = false;
    }
}

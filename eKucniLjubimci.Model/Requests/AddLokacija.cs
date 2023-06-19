using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddLokacija
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Drzava-")]
        public string Drzava { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Grad-")]
        public string Grad { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Ulica-")]
        public string Ulica { get; set; }
    }
}

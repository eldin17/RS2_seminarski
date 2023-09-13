using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddRasa
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Naziv-")]
        public string Naziv { get; set; }
    }
}

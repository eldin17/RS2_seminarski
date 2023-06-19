using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddProdavac
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -PoslovnaJedinica-")]
        public string PoslovnaJedinica { get; set; }
        public string SlikaProdavca { get; set; } = "empty";


        [Required(ErrorMessage = "Obavezno polje -OsobaId-")]
        public int OsobaId { get; set; }

        [Required(ErrorMessage = "Obavezno polje -KorisnickiNalogId-")]
        public int KorisnickiNalogId { get; set; }
    }
}

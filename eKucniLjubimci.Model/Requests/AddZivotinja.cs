using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddZivotinja
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Naziv-")]
        public string Naziv { get; set; }
        public string Napomena { get; set; } = "";
        [Required(ErrorMessage = "Obavezno polje -Cijena-")]
        [Range(1,100000,ErrorMessage ="Cijena mora biti u rasponu 1-100 000")]
        public decimal Cijena { get; set; }
        public bool Dostupnost { get; set; } = true;
        public DateTime DatumPostavljanja { get; set; } = DateTime.UtcNow;
        public string StateMachine { get; set; } = "Initial";


        [Required(ErrorMessage = "Obavezno polje -VrstaId-")]
        public int VrstaId { get; set; }

    }
}

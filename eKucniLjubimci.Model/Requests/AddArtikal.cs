using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddArtikal
    {
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Naziv-")]
        public string Naziv { get; set; }
        [Required(ErrorMessage = "Obavezno polje -Cijena-")]
        [Range(1, 100000, ErrorMessage = "Cijena mora biti u rasponu 1-100 000")]
        public decimal Cijena { get; set; }
        public bool Dostupnost { get; set; } = true;
        [Required(ErrorMessage = "Obavezno polje -Opis-")]
        public string Opis { get; set; }
        public string StateMachine { get; set; } = "Initial";

        [Required(ErrorMessage = "Obavezno polje -KategorijaId-")]
        public int KategorijaId { get; set; }

        //public virtual List<Slika> Slike { get; set; }
    }
}


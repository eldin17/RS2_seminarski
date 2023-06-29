using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddKupac
    {
        public int BrojNarudzbi { get; set; } = 0;

        public bool Kuca { get; set; } = false;
        public bool Dvoriste { get; set; } = false;
        public bool Stan { get; set; } = false;
        [Required(ErrorMessage = "Obavezno polje -OsobaId-")]
        public int OsobaId { get; set; }
        [Required(ErrorMessage = "Obavezno polje -LokacijaId-")]
        public int LokacijaId { get; set; }
        public string SlikaKupca { get; set; } = "http://localhost:7152/SlikeKupaca/Logo.jpg";
        [Required(ErrorMessage = "Obavezno polje -KorisnickiNalogId-")]
        public int KorisnickiNalogId { get; set; }

    }
}

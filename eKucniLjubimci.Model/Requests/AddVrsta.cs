﻿using System;
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
        [Required(ErrorMessage = "Obavezno polje -RasaId-")]
        public int RasaId { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Opis-")]
        public string Opis { get; set; }
        [Required(AllowEmptyStrings = false, ErrorMessage = "Obavezno polje -Boja-")]
        public string Boja { get; set; }

        [Range(1, 100, ErrorMessage = "Starost mora biti u rasponu 1-100")]
        public int Starost { get; set; }
        public bool Prostor { get; set; } = false;
    }
}

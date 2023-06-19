using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.DataTransferObjects
{
    public class DtoVrsta
    {
        public int VrstaId { get; set; }
        public string Naziv { get; set; }
        public string Rasa { get; set; }
        public string Opis { get; set; }
        public string Boja { get; set; }
        public int Starost { get; set; }
        public bool Prostor { get; set; }

    }
}

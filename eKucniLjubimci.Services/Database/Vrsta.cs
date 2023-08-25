using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Vrsta
    {
        public int VrstaId { get; set; }
        public string Naziv { get; set; }
        public string Opis { get; set; }
        public string Boja { get; set; }
        public int Starost { get; set; }
        public bool Prostor { get; set; }
        public bool isDeleted { get; set; } = false;

        public virtual List<Zivotinja> Zivotinje { get; set; }

        public int RasaId { get; set; }
        public virtual Rasa Rasa { get; set; }


    }
}

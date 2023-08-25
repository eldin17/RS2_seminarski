using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Rasa
    {
        public int RasaId { get; set; }
        public string Naziv { get; set; }
        public virtual List<Vrsta> Vrste { get; set; }
    }
}

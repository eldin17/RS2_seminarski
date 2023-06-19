using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddZivotinja
    {
        public string Naziv { get; set; }
        public string Napomena { get; set; }
        public decimal Cijena { get; set; }
        public bool Dostupnost { get; set; } = true;
        public DateTime DatumPostavljanja { get; set; } = DateTime.UtcNow;
        public string StateMachine { get; set; } = "Initial";

        

        public int VrstaId { get; set; }

    }
}

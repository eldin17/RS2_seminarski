using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.DataTransferObjects
{
    public class DtoZivotinja
    {
        public int ZivotinjaId { get; set; }
        public string Naziv { get; set; }
        public string Napomena { get; set; }
        public decimal Cijena { get; set; }
        public bool Dostupnost { get; set; }
        public DateTime DatumPostavljanja { get; set; }
        public string StateMachine { get; set; }

        

        public int VrstaId { get; set; }
        public virtual DtoVrsta Vrsta { get; set; }

        public virtual List<DtoSlika> Slike { get; set; }
    }
}

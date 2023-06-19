using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class Narudzba
    {
        public int NarudzbaId { get; set; }
        public DateTime DatumNarudzbe { get; set; }
        public decimal TotalFinal { get; set; }
        public string StateMachine { get; set; }

        
        public virtual Kupac Kupac { get; set; }
        public int KupacId { get; set; }

        public virtual List<NarudzbaArtikal> NarudzbeArtikli { get; set; } = new List<NarudzbaArtikal>();

        public virtual List<Zivotinja> Zivotinje { get; set; }=new List<Zivotinja>();

    }
}

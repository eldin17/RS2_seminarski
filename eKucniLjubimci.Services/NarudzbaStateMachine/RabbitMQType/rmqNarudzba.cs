using eKucniLjubimci.Model.DataTransferObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.NarudzbaStateMachine.RabbitMQType
{
    public class rmqNarudzba
    {
        public int NarudzbaId { get; set; }
        public DateTime DatumNarudzbe { get; set; }
        public decimal TotalFinal { get; set; }
        public string StateMachine { get; set; }


        public virtual DtoKupac Kupac { get; set; }
        public int KupacId { get; set; }

        public virtual List<DtoNarudzbaArtikal> NarudzbeArtikli { get; set; }

        public virtual List<DtoZivotinja> Zivotinje { get; set; }
        public string Funkcija { get; set; } = "";
    }
}

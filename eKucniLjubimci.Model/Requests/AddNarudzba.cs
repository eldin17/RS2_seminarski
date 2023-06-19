using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddNarudzba
    {
        public DateTime DatumNarudzbe { get; set; } = DateTime.UtcNow;
        public decimal TotalFinal { get; set; }
        public string StateMachine { get; set; } = "Initial";


        public int KupacId { get; set; }
    }
}

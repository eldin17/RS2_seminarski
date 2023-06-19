using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddNarudzba
    {
        public DateTime DatumNarudzbe { get; set; } = DateTime.UtcNow;
        public decimal TotalFinal { get; set; } = 0;
        public string StateMachine { get; set; } = "Initial";

        [Required(ErrorMessage = "Obavezno polje -KupacId-")]
        public int KupacId { get; set; }
    }
}

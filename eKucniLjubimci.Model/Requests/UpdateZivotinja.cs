using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class UpdateZivotinja
    {
        public string? Naziv { get; set; }
        public string? Napomena { get; set; }
        public decimal? Cijena { get; set; }
        public bool? Dostupnost { get; set; }        

        public int? VrstaId { get; set; }
    }
}

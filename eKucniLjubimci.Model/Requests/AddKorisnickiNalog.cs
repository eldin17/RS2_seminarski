using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class AddKorisnickiNalog
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public int UlogaId { get; set; }
        public DateTime DatumRegistracije { get; set; }= DateTime.UtcNow;

    }
}

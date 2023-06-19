using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class KorisnickiNalog
    {
        public int KorisnickiNalogId { get; set; }
        public string Username { get; set; }
        public byte[] PasswordHash { get; set; }
        public byte[] PasswordSalt { get; set; }
        public DateTime DatumRegistracije { get; set; }
        public bool isDeleted { get; set; } = false;

        public virtual Kupac? Kupac { get; set; }
        public virtual Prodavac? Prodavac { get; set; }

        public int UlogaId { get; set; }
        public virtual Uloga Uloga { get; set; }

    }
}

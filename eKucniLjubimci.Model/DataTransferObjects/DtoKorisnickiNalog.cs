using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.DataTransferObjects
{
    public class DtoKorisnickiNalog
    {
        public int KorisnickiNalogId { get; set; }
        public string Username { get; set; }
        public DateTime DatumRegistracije { get; set; }     


        

        public virtual DtoUloga Uloga { get; set; }
    }
}

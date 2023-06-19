using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.DataTransferObjects
{
    public class DtoProdavac
    {
        public int ProdavacId { get; set; }
        public string PoslovnaJedinica { get; set; }
        public string SlikaProdavca { get; set; }


        public int OsobaId { get; set; }
        public virtual DtoOsoba Osoba { get; set; }

        public virtual DtoKorisnickiNalog KorisnickiNalog { get; set; }
        public int KorisnickiNalogId { get; set; }
    }
}

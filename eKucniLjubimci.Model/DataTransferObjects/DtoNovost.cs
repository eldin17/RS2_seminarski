using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.DataTransferObjects
{
    public class DtoNovost
    {
        public int NovostId { get; set; }
        public string Naslov { get; set; }
        public string Sadrzaj { get; set; }
        public DateTime DatumPostavljanja { get; set; }

        public int ProdavacId { get; set; }
        public virtual DtoProdavac Prodavac { get; set; }
    }
}

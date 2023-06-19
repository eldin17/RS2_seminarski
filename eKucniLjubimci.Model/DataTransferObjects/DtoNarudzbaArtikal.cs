using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.DataTransferObjects
{
    public class DtoNarudzbaArtikal
    {
        public int NarudzbaArtikalId { get; set; }
        public int NarudzbaId { get; set; }

        public int ArtikalId { get; set; }
        public virtual DtoArtikal Artikal { get; set; }

    }
}

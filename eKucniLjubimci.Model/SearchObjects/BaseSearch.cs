using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.SearchObjects
{
    public class BaseSearch
    {
        public int? PageNumber { get; set; }
        public int? ItemsPerPage { get; set; }
    }
}

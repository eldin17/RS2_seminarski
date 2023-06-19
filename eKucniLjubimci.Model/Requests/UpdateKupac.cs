using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Model.Requests
{
    public class UpdateKupac
    {
        public bool? Kuca { get; set; } = false;
        public bool? Dvoriste { get; set; } = false;
        public bool? Stan { get; set; } = false;
    }
}

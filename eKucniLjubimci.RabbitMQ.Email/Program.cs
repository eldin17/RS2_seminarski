using eKucniLjubimci.Services;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using MimeKit.Text;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;




var factory = new ConnectionFactory { HostName = "localhost", Port = 5672, UserName = "guest", Password = "guest" };
using var connection = factory.CreateConnection();
using var channel = connection.CreateModel();

channel.QueueDeclare(queue: "eKucniljubimciQueue",
                     durable: false,
                     exclusive: false,
                     autoDelete: false,
                     arguments: null);
Console.WriteLine("Seminarski rad eKucniLjubimci, RabbitMQ demonstracija\n");
Console.WriteLine(" [*] Waiting for messages.");

var consumer = new EventingBasicConsumer(channel);
consumer.Received += (model, ea) =>
{        
    try
    {
        byte[] body = ea.Body.ToArray();
        string json = Encoding.UTF8.GetString(body);
        rmqMailDetails receivedObject = JsonConvert.DeserializeObject<rmqMailDetails>(json);

        Console.WriteLine($"\n [x] Received {receivedObject.EmailContent}");


        var email = new MimeMessage();
        email.From.Add(MailboxAddress.Parse(receivedObject.AdressFrom));
        email.To.Add(MailboxAddress.Parse(receivedObject.AdressTo));
        email.Subject = "RabbitMQ-eKucniLjubimci";
        email.Body = new TextPart(TextFormat.Html) { Text = receivedObject.EmailContent };


        using var smtp = new SmtpClient();
        smtp.ServerCertificateValidationCallback = (s, c, h, e) => true;
        smtp.Connect(receivedObject.SmtpMail, 587, SecureSocketOptions.Auto);
        smtp.Authenticate(receivedObject.AdressFrom, receivedObject.MailPassword);
        smtp.Send(email);
        smtp.Disconnect(true);

        Console.WriteLine("Slanje maila uspjesno (provjeriti Ethereal)...");
    }
    catch (Exception e)
    {
        Console.WriteLine("Slanje maila neuspjesno...");
        Console.WriteLine(e.ToString());
    }
};
channel.BasicConsume(queue: "eKucniljubimciQueue",
                     autoAck: true,
                     consumer: consumer);

Console.WriteLine(" Press [enter] to exit.");
Console.ReadLine();












//using MailKit.Net.Smtp;
//using MailKit.Security;
//using MimeKit;
//using MimeKit.Text;
//using RabbitMQ.Client;
//using RabbitMQ.Client.Events;
//using System.Text;

////var hostname = Environment.GetEnvironmentVariable("RabbitMQ_HostName");
////var user = Environment.GetEnvironmentVariable("RabbitMQ_UserName");
////var pw = Environment.GetEnvironmentVariable("RabbitMQ_Password");
////var from = Environment.GetEnvironmentVariable("RabbitMQ_MailAdressFrom");
////var to = Environment.GetEnvironmentVariable("RabbitMQ_MailAdressTo");
////var mailPw = Environment.GetEnvironmentVariable("RabbitMQ_MailAdressPassword");
////var smtpMail = Environment.GetEnvironmentVariable("RabbitMQ_MailSMTP");
////var factory = new ConnectionFactory { HostName = hostname, UserName = user, Password = pw };

//var factory = new ConnectionFactory { HostName = "localhost", UserName = "guest", Password = "guest" };
//using var connection = factory.CreateConnection();
//using var channel = connection.CreateModel();

//channel.QueueDeclare(queue: "eKucniljubimciQueue",
//                     durable: false,
//                     exclusive: false,
//                     autoDelete: false,
//                     arguments: null);
//Console.WriteLine("Seminarski rad eKucniLjubimci, RabbitMQ demonstracija\n");
//Console.WriteLine(" [*] Waiting for messages.");

//var consumer = new EventingBasicConsumer(channel);
//consumer.Received += (model, ea) =>
//{
//    var body = ea.Body.ToArray();
//    var message = Encoding.UTF8.GetString(body);
//    Console.WriteLine($" [x] Received {message}");
//    //------------------------------------------------------------------------
//    try
//    {
//        var email = new MimeMessage();
//        email.From.Add(MailboxAddress.Parse("garrett.reichel51@ethereal.email"));
//        email.To.Add(MailboxAddress.Parse("garrett.reichel51@ethereal.email"));
//        email.Subject = "RabbitMQ-eKucniLjubimci";
//        email.Body = new TextPart(TextFormat.Html) { Text = message };


//        using var smtp = new SmtpClient();
//        smtp.ServerCertificateValidationCallback = (s, c, h, e) => true;
//        smtp.Connect("smtp.ethereal.email", 587, SecureSocketOptions.Auto);
//        smtp.Authenticate("garrett.reichel51@ethereal.email", "dE4DagZHn2MPvxpqek");
//        smtp.Send(email);
//        smtp.Disconnect(true);

//        Console.WriteLine("Slanje maila uspjesno (provjeriti Ethereal)...");

//        //var email = new MimeMessage();
//        //email.From.Add(MailboxAddress.Parse(from));
//        //email.To.Add(MailboxAddress.Parse(to));
//        //email.Subject = "RabbitMQ-eKucniLjubimci";
//        //email.Body = new TextPart(TextFormat.Html) { Text = message };


//        //using var smtp = new SmtpClient();
//        //smtp.ServerCertificateValidationCallback = (s, c, h, e) => true;
//        //smtp.Connect(smtpMail, 587, SecureSocketOptions.Auto);
//        //smtp.Authenticate(from, mailPw);
//        //smtp.Send(email);
//        //smtp.Disconnect(true);

//        //Console.WriteLine("Slanje maila uspjesno (provjeriti Ethereal)...");
//    }
//    catch (Exception e)
//    {
//        Console.WriteLine("Slanje maila neuspjesno...");
//        Console.WriteLine(e.ToString());
//    }
//};
//channel.BasicConsume(queue: "eKucniljubimciQueue",
//                     autoAck: true,
//                     consumer: consumer);

//Console.WriteLine(" Press [enter] to exit.");
//Console.ReadLine();
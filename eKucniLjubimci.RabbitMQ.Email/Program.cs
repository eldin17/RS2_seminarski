using eKucniLjubimci.RabbitMQ.Email;

class Program
{
    static void Main(string[] args)
    {
        var receiver = new Receiver();
        receiver.StartReceiving();
    }
}




//using eKucniLjubimci.RabbitMQ.Email;
//using MailKit.Net.Smtp;
//using MailKit.Security;
//using MimeKit;
//using MimeKit.Text;
//using Newtonsoft.Json;
//using RabbitMQ.Client;
//using RabbitMQ.Client.Events;
//using System.Text;

//var factory = new ConnectionFactory
//{
//    HostName = Environment.GetEnvironmentVariable("RabbitMQ_HostName") ?? "localhost",
//    Port = int.Parse(Environment.GetEnvironmentVariable("RabbitMQ_Port") ?? "5672"),
//    UserName = Environment.GetEnvironmentVariable("RabbitMQ_UserName") ?? "guest",
//    Password = Environment.GetEnvironmentVariable("RabbitMQ_Password") ?? "guest",
//};
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
//    try
//    {
//        byte[] body = ea.Body.ToArray();
//        string json = Encoding.UTF8.GetString(body);
//        rmqMailDetails receivedObject = JsonConvert.DeserializeObject<rmqMailDetails>(json);

//        Console.WriteLine($"\n [x] Received {receivedObject.EmailContent}");


//        var email = new MimeMessage();
//        email.From.Add(MailboxAddress.Parse(receivedObject.AdressFrom));
//        email.To.Add(MailboxAddress.Parse(receivedObject.AdressTo));
//        email.Subject = "RabbitMQ-eKucniLjubimci";
//        email.Body = new TextPart(TextFormat.Html) { Text = receivedObject.EmailContent };


//        using var smtp = new SmtpClient();
//        smtp.ServerCertificateValidationCallback = (s, c, h, e) => true;
//        smtp.Connect(receivedObject.SmtpMail, receivedObject.MailPort, SecureSocketOptions.Auto);
//        smtp.Authenticate(receivedObject.AdressFrom, receivedObject.MailPassword);
//        smtp.Send(email);
//        smtp.Disconnect(true);

//        Console.WriteLine("Slanje maila uspjesno (provjeriti Ethereal)...");
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

////Console.WriteLine(" Press [enter] to exit.");
////Console.ReadLine();
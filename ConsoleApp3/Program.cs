using System;

class Consoleapp3
{
    public class Student
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public double Score { get; set; }
    }

    static void Main()
    {
        Student[] students = new Student[]
        {
            new Student { Id = 1, Name = "Alice", Score = 3 },
            new Student { Id = 2, Name = "Bob", Score = 7.87 },
            new Student { Id = 3, Name = "Charlie", Score = 9.001 },
            new Student { Id = 4, Name = "David", Score = 11 },
            new Student { Id = 5, Name = "Eve", Score = 13 },
            new Student { Id = 6, Name = "Frank", Score = 8 },
            new Student { Id = 7, Name = "Grace", Score = 9 },
            new Student { Id = 8, Name = "Hannah", Score = 9.2 },
            new Student { Id = 9, Name = "Isaac", Score = 8.86 }
        };

        foreach (var student in students)
        {
            int roundedScore = (int)Math.Ceiling(student.Score);

            string result = roundedScore < 10 ? "Fail" : "Pass";

            Console.WriteLine($"Name: {student.Name}Grade: {roundedScore}, Results: {result}");
        }
    }
}
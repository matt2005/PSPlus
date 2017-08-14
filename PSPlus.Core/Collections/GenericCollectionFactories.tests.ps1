﻿Import-Module "$PSScriptRoot\..\..\PSPlus.psd1" -Force

Describe "GenericCollectionFactories" {
    Context "When using list" {
        It "Should be able to use list" {
            $collection = New-GenericList "int"
            $collection.Count | Should Be 0

            $collection.Add(1)
            $collection.Count | Should Be 1

            $collection.Clear()
            $collection.Count | Should Be 0
        }
    }

    Context "When using queue" {
        It "Should be able to use queue" {
            $collection = New-GenericQueue "int"
            $collection.Count | Should Be 0

            $collection.Enqueue(1)
            $collection.Count | Should Be 1

            $collection.Dequeue() | Should Be 1
            $collection.Count | Should Be 0
        }
    }

    Context "When using stack" {
        It "Should be able to use stack" {
            $collection = New-GenericStack "int"
            $collection.Count | Should Be 0

            $collection.Push(1)
            $collection.Count | Should Be 1

            $collection.Pop() | Should Be 1
            $collection.Count | Should Be 0
        }
    }

    Context "When using set" {
        It "Should be able to use stack" {
            $collection = New-GenericSet "int"
            $collection.Count | Should Be 0
            $collection.Contains(1) | Should Be $false

            $collection.Add(1)
            $collection.Count | Should Be 1
            $collection.Contains(1) | Should Be $true

            $collection.Remove(1) | Should Be 1
            $collection.Count | Should Be 0
            $collection.Contains(1) | Should Be $false
        }
    }

    Context "When using dictionary" {
        It "Should be able to use dictionary" {
            $collection = New-GenericDictionary "int" "string"
            $collection.Count | Should Be 0
            $collection.ContainsKey(1) | Should Be $false

            $collection.Add(1, "test")
            $collection.Count | Should Be 1
            $collection.ContainsKey(1) | Should Be $true
            $collection[1] | Should Be "test"

            $collection.Remove(1)
            $collection.Count | Should Be 0
            $collection.ContainsKey(1) | Should Be $false
        }
    }
}

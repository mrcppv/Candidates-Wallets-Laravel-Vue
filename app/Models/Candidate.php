<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Candidate extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'email',
        'description',
        'strengths',
        'soft_skills',
        'hired',
        'contactedby'
    ];

    public function strengths()
    {
        return json_decode($this->strengths);
    }

    public function softSkills()
    {
        return json_decode($this->soft_skills);
    }
}

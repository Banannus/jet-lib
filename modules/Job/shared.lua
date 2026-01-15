local Job = {}

function Job.RunActionForJob(job, action)
    return impl.runActionForJob(job, action)
end

function Job.GetJobCount(job)
    return impl.getJobCount(job)
end

return Job